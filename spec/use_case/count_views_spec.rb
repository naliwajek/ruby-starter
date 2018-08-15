describe UseCase::CountViews do
  let(:file_gateway) { double('Gateway::File') }
  before do
    allow(file_gateway).to receive(:readlines)
      .and_return(lines_array)
  end

  subject do
    described_class.new(
      file_gateway: file_gateway,
      count_strategy: count_strategy,
      order_strategy: order_strategy
    ).execute(
      presenter: presenter
    )
  end

  context 'counting all visits descending as a printable list' do
    let(:count_strategy) { Strategy::StandardCount }
    let(:order_strategy) { Strategy::DescendingOrder }
    let(:presenter) { Presenter::PrintableList.new(title: 'visits') }

    context 'when file is empty' do
      let(:lines_array) { [] }

      it 'returns an empty hash' do
        expect(subject).to eq('')
      end
    end

    context 'only one entry' do
      let(:lines_array) { ['/ 127.0.0.1'] }

      it 'returns count for that one entry' do
        expect(subject).to eq(
          "/ 1 visits\n"
        )
      end
    end

    context 'multiple entries for same URL' do
      let(:lines_array) do
        [
          '/ 127.0.0.1',
          '/ 127.0.0.1',
          '/ 127.0.0.1'
        ]
      end

      it 'still counts them all as seperate' do
        expect(subject).to eq(
          "/ 3 visits\n"
        )
      end
    end

    context 'even multiple number of entries for multiple URLs' do
      let(:lines_array) do
        [
          '/ 127.0.0.1',
          '/ 127.0.0.1',
          '/home 168.0.0.1',
          '/home 168.0.0.1',
          '/ 168.0.0.1',
          '/ 192.0.0.1',
          '/home 192.0.0.1',
          '/home 127.0.0.1',
        ]
      end

      it 'counts them all' do
        expect(subject).to eq(
          "/ 4 visits\n/home 4 visits\n"
        )
      end
    end

    context 'different number of entries' do
      let(:lines_array) do
        [
          '/ghi 127.0.0.1',
          '/ghi 192.0.0.1',
          '/ghi 168.0.0.1',
          '/ghi 168.0.0.1',
          '/def 192.0.0.1',
          '/def 168.0.0.1',
          '/abc 127.0.0.1',
          '/abc 192.0.0.1',
          '/abc 168.0.0.1',
        ]
      end

      it 'counts them and sorts from high to low' do
        expect(subject).to eq(
          "/ghi 4 visits\n/abc 3 visits\n/def 2 visits\n"
        )
      end
    end
  end

  context 'counting only unique visits ascending as a JSON response' do
    let(:count_strategy) { Strategy::UniqueCount }
    let(:order_strategy) { Strategy::AscendingOrder }
    let(:presenter) { Presenter::JsonResponse.new(title: 'unique visits') }

    context 'when file is empty' do
      let(:lines_array) { [] }

      it 'returns an empty hash' do
        expect(JSON.parse(subject)).to eq({ 
          'type' => 'unique visits',
          'views' => []
        })
      end
    end

    context 'only one entry' do
      let(:lines_array) { ['/ 127.0.0.1'] }

      it 'returns count for that one entry' do
        expect(JSON.parse(subject)).to eq({ 
          'type' => 'unique visits',
          'views' => [
            {
              'position' => 0,
              'url' => '/',
              'count' => 1
            }
          ]
        })
      end
    end

    context 'multiple entries for same URL' do
      let(:lines_array) do
        [
          '/ 127.0.0.1',
          '/ 127.0.0.1',
          '/ 127.0.0.1'
        ]
      end

      it 'counts them as one unique view' do
        expect(JSON.parse(subject)).to eq({ 
          'type' => 'unique visits',
          'views' => [
            {
              'position' => 0,
              'url' => '/',
              'count' => 1
            }
          ]
        })
      end
    end

    context 'even multiple number of entries for multiple URLs' do
      let(:lines_array) do
        [
          '/ 127.0.0.1',
          '/ 127.0.0.1',
          '/home 168.0.0.1',
          '/home 168.0.0.1',
          '/ 168.0.0.1',
          '/ 192.0.0.1',
          '/home 192.0.0.1',
          '/home 127.0.0.1',
        ]
      end

      it 'counts them all uniquely' do
        expect(JSON.parse(subject)).to eq({ 
          'type' => 'unique visits',
          'views' => [
            {
              'position' => 0,
              'url' => '/',
              'count' => 3
            },
            {
              'position' => 1,
              'url' => '/home',
              'count' => 3
            }
          ]
        })
      end
    end

    context 'different number of entries' do
      let(:lines_array) do
        [
          '/ghi 127.0.0.1',
          '/ghi 192.0.0.1',
          '/ghi 168.0.0.1',
          '/ghi 168.0.0.1',
          '/def 168.0.0.1',
          '/def 168.0.0.1',
          '/abc 127.0.0.1',
          '/abc 127.0.0.1',
          '/abc 168.0.0.1',
        ]
      end

      it 'counts them uniquely and sorts from low to high' do
        expect(JSON.parse(subject)).to eq({ 
          'type' => 'unique visits',
          'views' => [
            {
              'position' => 0,
              'url' => '/def',
              'count' => 1
            },
            {
              'position' => 1,
              'url' => '/abc',
              'count' => 2
            },
            {
              'position' => 2,
              'url' => '/ghi',
              'count' => 3
            }
          ]
        })
      end
    end
  end
end