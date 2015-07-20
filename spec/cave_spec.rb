require_relative "../lib/cave"

RSpec.describe Cave do
  def clean_up_picture(picture)
    picture.gsub(/^ +/, '').strip + "\n"
  end

  def picture_to_cave(picture)
    Cave.parse(clean_up_picture(picture))
  end

  def expect_pump_result(initial_cave_picture, resulting_cave_picture, units=1)
    cave = picture_to_cave(initial_cave_picture)
    units.times do
      cave.pump
    end
    expect(cave.to_s).to eql(clean_up_picture(resulting_cave_picture))
    cave
  end

  it "flows horizontally when over rock" do
    cave = expect_pump_result(<<-end_before, <<-end_after)
      ################################
      ~                              #
      #         ####                 #
      ###       ####                ##
      ###       ####              ####
      #######   #######         ######
      #######   ###########     ######
      ################################
    end_before
      ################################
      ~~                             #
      #         ####                 #
      ###       ####                ##
      ###       ####              ####
      #######   #######         ######
      #######   ###########     ######
      ################################
    end_after
    expect(cave.water_units).to eq(2)
  end

  it "flows vertically first when air is below" do
    expect_pump_result(<<-end_before, <<-end_after)
      ################################
      ~~                             #
      #         ####                 #
      ###       ####                ##
      ###       ####              ####
      #######   #######         ######
      #######   ###########     ######
      ################################
    end_before
      ################################
      ~~                             #
      #~        ####                 #
      ###       ####                ##
      ###       ####              ####
      #######   #######         ######
      #######   ###########     ######
      ################################
    end_after
  end

  it "matches the 45 unit flow example" do
    expect_pump_result(<<-end_before, <<-end_after, 44)
      ################################
      ~                              #
      #         ####                 #
      ###       ####                ##
      ###       ####              ####
      #######   #######         ######
      #######   ###########     ######
      ################################
    end_before
      ################################
      ~~~~~~~~~~~~~~~                #
      #~~~~~~~~~####~                #
      ###~~~~~~~####                ##
      ###~~~~~~~####              ####
      #######~~~#######         ######
      #######~~~###########     ######
      ################################
    end_after
  end

  it "counts the total water units" do
    cave = picture_to_cave(<<-end_picture)
      ################################
      ~~~~~~~~~~~~~~~                #
      #~~~~~~~~~####~                #
      ###~~~~~~~####                ##
      ###~~~~~~~####              ####
      #######~~~#######         ######
      #######~~~###########     ######
      ################################
    end_picture
    expect(cave.water_units).to eq(45)
    cave.pump
    expect(cave.water_units).to eq(46)
  end

  it "matches the 100 unit flow example" do
    expect_pump_result(<<-end_before, <<-end_after, 99)
      ################################
      ~                              #
      #         ####                 #
      ###       ####                ##
      ###       ####              ####
      #######   #######         ######
      #######   ###########     ######
      ################################
    end_before
      ################################
      ~~~~~~~~~~~~~~~                #
      #~~~~~~~~~####~~~~~~~~~~~~     #
      ###~~~~~~~####~~~~~~~~~~~~~~~~##
      ###~~~~~~~####~~~~~~~~~~~~~~####
      #######~~~#######~~~~~~~~~######
      #######~~~###########~~~~~######
      ################################
    end_after
  end

  it "can return depth measurements after 45 units" do
    cave = picture_to_cave(<<-end_picture)
      ################################
      ~~~~~~~~~~~~~~~                #
      #~~~~~~~~~####~                #
      ###~~~~~~~####                ##
      ###~~~~~~~####              ####
      #######~~~#######         ######
      #######~~~###########     ######
      ################################
    end_picture
    expect(cave.depths.map(&:to_s)).to eq %w(1 2 2 4 4 4 4 6 6 6 1 1 1 1 ~ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  end

  it "can return depth measurements after 100 units" do
    cave = picture_to_cave(<<-end_picture)
      ################################
      ~~~~~~~~~~~~~~~                #
      #~~~~~~~~~####~~~~~~~~~~~~     #
      ###~~~~~~~####~~~~~~~~~~~~~~~~##
      ###~~~~~~~####~~~~~~~~~~~~~~####
      #######~~~#######~~~~~~~~~######
      #######~~~###########~~~~~######
      ################################
    end_picture
    expect(cave.depths.map(&:to_s)).to eq %w(1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0)
  end
end
