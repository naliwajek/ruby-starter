describe Gateway::File do
  let(:path) { 'spec/fixtures/data/webserver.log' }

  it 'returns array of all the lines in a file' do
    expect(described_class.new(path: path).readlines).to eq(
      [
        '/ 127.0.0.1',
        '/search 127.0.0.1'
      ]
    )
  end
end
