describe 'counts visits for real data' do
  let(:file_gateway) { Gateway::File.new(path: './data/webserver.log') } 
  let(:all_descending) do
    UseCase::CountViews.new(
      file_gateway: file_gateway,
      count_strategy: Strategy::StandardCount,
      order_strategy: Strategy::DescendingOrder
    )
  end

  context 'all visits' do
    it 'calculates all visits on real data' do
      result = all_descending.execute(
        presenter: Presenter::JsonResponse.new(title: 'visits')
      )

      expect(JSON.parse(result)).to eq({
        "type" => 'visits',
        "views" => [
          {
            "count" => 90, 
            "position" => 0, 
            "url" => "/about/2"
          },{
            "count" => 89,
            "position" => 1,
            "url" => "/contact"
          },{
            "count" => 82,
            "position" => 2,
            "url" => "/index"
          },{
            "count" => 81,
            "position" => 3,
            "url" => "/about"
            },{
              "count" => 80,
              "position" => 4,
              "url" => "/help_page/1"
            },{
              "count" => 78,
              "position" => 5,
              "url" => "/home"
            }
          ] 
        }
      )
    end
  end

  # ... and we would write more IRL ...
end