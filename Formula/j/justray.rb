class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "f85a7515f8986032402074e22d705ec2d4f800aea3a56736c47f6c6c0f85ab3c"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "559079e73fda99f270e5a51f492626b070c2cafe6e82b80a92b665509ac6795a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d10f9723906a02bc6f8746b61e69dbc10aa10051555aaa6899a59ddf3fe5e74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed67bab9290ef51394a2fab0231bc1dcc054a3b117a4ea09b9e62c775909c97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a44aad88f87c9d961a12b9b9c9a57d69057df1cf38328b7e6d2e9ed32ee7325"
    sha256 cellar: :any,                 x86_64_linux:  "00befb2cd3b99aa59e76c7c6180559388b0e2299f3003270df4acbe46399804c"
  end

  # Match upstream release CI; sing-box relies on private HTTP/2 symbols.
  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/luynrs/justray/internal/version.Version=#{version}"
    tags = "with_quic,with_utls,with_gvisor,with_grpc,with_xhttp"
    %w[justray justrayd].each do |name|
      system "go", "build", *std_go_args(output: bin/name, ldflags:), "-tags=#{tags}", "./cmd/#{name}"
    end
    bin.install_symlink "justray" => "jray"
    generate_completions_from_executable(bin/"justray", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"justrayd"]
    keep_alive true
    log_path var/"log/justrayd.log"
    error_log_path var/"log/justrayd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/justray --version")
    assert_path_exists bin/"justrayd"
    output = shell_output("#{bin}/justray invalid-command 2>&1", 1)
    assert_match 'unknown command "invalid-command"', output
  end
end
