class Curlmin < Formula
  desc "Remove unnecessary headers, cookies, and query parameters from a curl command"
  homepage "https://github.com/noperator/curlmin"
  url "https://github.com/noperator/curlmin/archive/5b5e4eeeff42df354c822c3147206993638323d6.tar.gz"
  version "0.0.1"
  sha256 "ede81edd109f7ab2c4a4811f1187b740cb756bc796cfcfe7c3d32527c23a8191"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/curlmin"
  end

  test do
    curl_script = testpath/"curl.sh"
    curl_script.write <<~SH
      curl \
        -H 'Authorization: Bearer xyz789' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml' \
        -H 'Accept-Language: en-US,en;q=0.9' \
        -H 'Cache-Control: max-age=0' \
        -H 'Connection: keep-alive' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Cookie: _ga=GA1.2.1234567890.1623456789; session=abc123; _gid=GA1.2.9876543210.1623456789' \
        -H 'Cookie: _fbp=fb.1.1623456789.1234567890' \
        -H 'Cookie: _gat=1; thisis=notneeded' \
        -b 'preference=dark; language=en; theme=blue' \
        'http://example.com/api/test?auth_key=def456&timestamp=1623456789&tracking_id=abcdef123456&utm_source=test&utm_medium=cli&utm_campaign=curlmin'
    SH
    output = shell_output("#{bin}/curlmin -f #{curl_script}")
    assert_match "curl 'http://example.com/api/test?auth_key=def456'\n\n", output
  end
end
