require 'spec_helper'

describe Shop::CartController do

  let(:theme) { Factory :theme_woodland_dark }

  let(:shop) { Factory(:user).shop }

  let(:iphone4) { Factory :iphone4, shop: shop }

  let(:variant) { iphone4.variants.first }

  before :each do
    shop.themes.install theme
    request.host = "#{shop.primary_domain.host}"
    session = mock('session')
    session.stub!(:[], 'cart').and_return("#{variant.id}|1")
    session.stub!(:[]=)
    controller.stub!(:session).and_return(session)
  end

  it 'should be update', focus: true do
    post :update, shop_id: shop.id, updates: [1]
    response.should be_redirect
  end

  it 'should be checkout' do
    expect do
      post :update, shop_id: shop.id, updates: {}, checkout: :checkout
    end.should change(Cart, :count).by(1)
  end

end
