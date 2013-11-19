class OrgsController < ApplicationController

before_filter :authenticate_user!, :except => [:index, :search, :show]

respond_to :html, :xml, :json, :csv

  def index
    render layout:"homepage"
  end

  def search
    @search = Org.search do 
      fulltext params[:search_terms]
      paginate :page => params[:page], :per_page=> 15
      order_by :transparency, :desc
      order_by :updated_at, :desc
      facet(:transparency)
      with(:transparency, params[:transparency]) if params[:transparency].present?
      facet(:locations)
      with(:locations, params[:locations]) if params[:locations].present?
      facet(:causes)
      with(:causes, params[:causes]) if params[:causes].present?
    end

  @search_results = @search.results
    
    respond_with(@search_results) do |format|
      format.html { render }
      format.json { render }
    end
  end


  def show
    @org = Org.find(params[:id])
    @primary_prov = @org.primary_province


    @funding_chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 0, 100,0], :renderTo=>'piechart', :width=>'300' })
      series = {
               :type=> 'pie',
               :name=> 'Browser share',
               :data=> [
                  ['Private',   45.0],
                  ['Government',       26.8],
                  ['Corporate',    8.5],
                  ['Other',     6.2],
               ]
      }
      f.series(series)
      f.options[:title][:text] = "Funding Sources"
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> 'auto',:top=> 'auto'}) 
      f.plot_options(:pie=>{
        :allowPointSelect=>true, 
        :cursor=>"pointer" , 
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end


    @other_chart = LazyHighCharts::HighChart.new('bar') do |f|
      f.chart({:renderTo=>'piechart2', :width=>'300'})
      f.series(:name=>'John',:data=> [3, 20, 3, 5])
      f.series(:name=>'Jane',:data=>[1, 3, 4, 3] )
      f.xAxis(:categories=>['Apples', 'Oranges','bycicle','sausages'])   
      f.title({ :text=>"Example bar chart title"})
      f.options[:chart][:defaultSeriesType] = "bar"
      f.plot_options({:series=>{:stacking=>"percent"}})
      f.plot_options({:bar=>{:dataLabels=>{:enabled => true}}})
    end

    respond_with(@org) do |format|
      format.html { render }
      format.json { render }
      format.csv { send_data @org.to_csv }
      format.xls { send_data @org.to_csv(col_sep: "\t") }
    end
  end


  def new
    @org = Org.new

    @legalnames = Legal.pluck(:legal_type)
    @affilitypes = ["International Foundation", "Business", "National Foundation", "International Government", "Local Government",
    "International Organization", "ONG", "Educational Institution"]
    @provincenames = Province.pluck(:name)
    @provinceids = Province.pluck(:id)
    @provincearray = @provincenames.zip(@provinceids)
    @legalnames = Legal.pluck(:legal_type)

    @org.objectives.build
    @org.branches.build
    @org.locations.build
    @org.programs.build
    @org.affiliations.build
    @org.networks.build
    @org.prizes.build
    @org.incomes.build
    @org.balances.build
    @org.bigdonors.build
    board = @org.build_board
    board.people.build
    advisory = @org.build_advisory
    advisory.people.build
    @org.build_legal
    # @org.ages.build

    @causes = Cause.all
    @ages = Age.all
    @provinces = Province.all
    @activities = Activity.all

    @agegroups = Age.pluck(:description)
  end



  def create

    puts "*" * 100
    puts params
    puts "*" * 100
    @org = current_user.build_org params[:org]
    @org.causes << Cause.where(:id => params[:causes])
    @org.ages << Age.where(:id => params[:ages])
    @org.locations << Location.where(:id => params[:provinces])
    @org.activities << Activity.where(:id => params[:activities])
    @org.user

    if @org.save
      redirect_to org_path(@org)
    else
      @errors = @org.errors.full_messages
      puts "*" * 80
      puts @errors
      puts "*" * 80
      redirect_to new_org_path
    end
  end
end


