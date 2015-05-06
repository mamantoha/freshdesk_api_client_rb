require 'core/spec_helper'

describe FreshdeskAPI::Resource do
  context "#initialize" do
    it "should require options as hash" do
      expect { FreshdeskAPI::TestResource.new(client, '{options: 1}') }.to raise_error(RuntimeError)
    end
  end

  context "#update" do
    context "class method" do
      let(:id) { '1' }
      subject { FreshdeskAPI::TestResource }

      before(:each) do
        stub_json_request(:put, %r{test/resources/#{id}}).with(body: { test_resource: { id: id, test: 'hello' } })
      end

      it "should return instance of resource" do
        expect(subject.update!(client, id: id, test: 'hello')).to be_truthy
      end

      context "with client error" do
        before(:each) do
          stub_request(:put, %r{test/resources/#{id}}).to_return(status: 500)
        end

        it "should handle it properly" do
          expect { expect(subject.update(client, id: id)).to be(false) }.to_not raise_error
        end
      end
    end
  end

  context "#destroy" do
    context "class method" do
      let(:id) { '1' }
      subject { FreshdeskAPI::TestResource }

      before(:each) do
        stub_json_request(:delete, %r{test/resources/#{id}})
      end

      it "should return instance of resource" do
        expect(subject.destroy!(client, id: id)).to be(true)
      end

      context "with client error" do
        before(:each) do
          stub_request(:delete, %r{test/resources/#{id}}).to_return(status: 500)
        end

        it "should handle it properly" do
          expect(subject.destroy(client, id: id)).to be(false)
        end
      end
    end

    context "instance method" do
      subject { FreshdeskAPI::TestResource.new(client, id: '1') }

      before(:each) do
        stub_request(:delete, %r{test/resources}).to_return(status: 200)
      end

      it "should return true and set destroyed" do
        expect(subject.destroy).to be(true)
        expect(subject.destroyed?).to be(true)
        expect(subject.destroy).to be(false)
      end
    end
  end

  context "#save!" do
    let(:id) { '1' }
    subject { FreshdeskAPI::TestResource.new(client, id: id) }

    before(:each) do
      stub_request(:put, %r{test/resources/#{id}}).to_return(status: 422)
    end

    it "should raise if save fails" do
      expect { subject.save! }.to raise_error
    end
  end

  context "#save" do
    let(:id) { '1' }
    let(:attr) { { param: "test" } }
    subject { FreshdeskAPI::TestResource.new(client, attr.merge(id: id)) }

    before :each do
      stub_json_request(:put, %r{test/resources/#{id}}, json(resource:  { param: "abc" }))
    end

    it "should not save if already destroyed" do
      expect(subject).to receive(:destroyed?).and_return(true)
      expect(subject.save).to be(false)
    end

    it "should not be a new record with an id" do
      expect(subject.new_record?).to be(false)
    end

    it "should put on save" do
      expect(subject.save).to be(subject)
      expect(subject.attributes[:param]).to eq("abc")
    end

    context "with client error" do
      before :each do
        stub_request(:put, %r{test/resources/#{id}}).to_return(status: 500)
      end

      it "should be properly handled" do
        expect { expect(subject.save).to be(false) }.to_not raise_error
      end
    end

    context "new record" do
      subject { FreshdeskAPI::TestResource.new(client, attr) }

      before :each do
        stub_json_request(:post, %r{test/resources}, json(resource: attr.merge(id: id)), status: 201)
      end

      it "should be true without an id" do
        expect(subject.new_record?).to be(true)
      end

      it "should be false after creating" do
        expect(subject.save).to be(subject)
        expect(subject.new_record?).to be(false)
        expect(subject.id).to eq(id)
      end
    end
  end

  context "#new" do
    it "builds with hash" do
      object = FreshdeskAPI::TestResource.new(client, {})
      expect(object.attributes).to eq({})
    end

    it "fails to build with nil (e.g. empty response from server)" do
      expect {
        FreshdeskAPI::TestResource.new(client, nil)
      }.to raise_error(/Expected a Hash/i)
    end

  end

  context "#inspect" do
    it "should display nicely" do
      expect(FreshdeskAPI::TestResource.new(client, foo: :bar).inspect).to eq("#<FreshdeskAPI::TestResource {:foo=>:bar}>")
    end
  end

  context "#==" do
    it "is same when id is same" do
      expect(FreshdeskAPI::TestResource.new(client, id: 1, bar: "baz")).to eq(FreshdeskAPI::TestResource.new(client, id: 1, foo: "bar"))
    end

    it "is same when object_id is same" do
      object = FreshdeskAPI::TestResource.new(client, bar: "baz")
      expect(object).to eq(object)
    end

    it "is different when both have no id" do
      expect(FreshdeskAPI::TestResource.new(client)).to_not eq(FreshdeskAPI::TestResource.new(client))
    end

    it "is different when id is different" do
      expect(FreshdeskAPI::TestResource.new(client, id: 2)).to_not eq(FreshdeskAPI::TestResource.new(client, id: 1))
    end

    it "is same when class is Data" do
      expect(FreshdeskAPI::TestResource.new(client, id: 2)).to eq(FreshdeskAPI::TestResource::TestChild.new(client, id: 2))
    end

    it "is different when other is no resource" do
      expect(FreshdeskAPI::TestResource.new(client, id: 2)).to_not eq(nil)
    end

    it "warns about weird comparissons" do
      object = FreshdeskAPI::TestResource.new(client, id: 2)
      expect(object).to receive(:warn)
      expect(object).to_not eq("xxx")
    end
  end
end
