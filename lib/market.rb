class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    names = @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    vendors = @vendors.find_all { |vendor| vendor.inventory.include?(item) }
  end

  def sorted_item_list
    all_items = []
    @vendors.each do |vendor|
      vendor.inventory.sort_by do |item|
        all_items << item.first.name
      end
    end
    all_items.flatten.uniq.sort
  end

  def list_all_items
    all_items = []
    @vendors.each do |vendor|
      vendor.inventory.sort_by do |item|
        all_items << item.first
      end
    end
    all_items.uniq
  end

  def vendors_that_sell_an_item(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def quantity_sold_by_vendors(item)
    total = 0
    @vendors.each do |vendor|
      total += vendor.check_stock(item)
    end
    total
  end

  def total_inventory
    all_items = list_all_items

    inventory = all_items.reduce({}) do |acc, item|
      acc[item] = Hash.new if !acc.has_key?(item)
      acc[item][:vendors] = vendors_that_sell_an_item(item)
      acc[item][:quantity] = quantity_sold_by_vendors(item)
      acc
    end
    inventory
  end
end
