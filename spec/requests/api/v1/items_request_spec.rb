require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_success

    items = JSON.parse(response.body)

    expect(items.count).to eq 3
  end

  it "can get one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(id)
  end

  it "can get one item by attribute" do
    dummy = create(:item)

    get "/api/v1/items/find?name=#{dummy.name}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(dummy.id)
  end

  it "can get one item by another attribute" do
    merchant = create(:merchant)
    id = create(:item, merchant: merchant).id

    get "/api/v1/items/find?merchant_id=#{merchant.id}"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(item['id']).to eq(id)
  end

  it "can get all items by attribute" do
    merchant = create(:merchant)
    create_list(:item, 4, merchant: merchant)

    get "/api/v1/items/find_all?merchant_id=#{merchant.id}"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(4)
  end

  it "can get all items by another attribute" do
    create_list(:item, 4, unit_price:0.3421)

    get "/api/v1/items/find_all?unit_price=0.3421"

    items = JSON.parse(response.body)

    expect(response).to be_success
    expect(items.count).to eq(4)
  end

  it "can return one random record" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)

    items = [item1.id, item2.id, item3.id]

    get "/api/v1/items/random"

    item = JSON.parse(response.body)

    expect(response).to be_success
    expect(items).to include(item['id'])
  end

  it "can return item with most revenue" do
    item1 = create(:item)
    item2 = create(:item)
    item3 = create(:item)
    invoice_items1 = create_list(:invoice_item, 4, item: item1, quantity: 5, unit_price: 1000)
    invoice_items2 = create_list(:invoice_item, 4, item: item2, quantity: 1, unit_price: 200)
    invoice_items3 = create_list(:invoice_item, 4, item: item3, quantity: 6, unit_price: 700)

    get "/api/v1/items/most_revenue?quantity=2"
    returned_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_success
    expect(returned_items[0][:id]).to eq(item1.id)
    expect(returned_items[1][:id]).to eq(item2.id)

  end
end
