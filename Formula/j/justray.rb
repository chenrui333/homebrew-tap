class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "f443ef09f37acdadc388f774491c3900c2cea82dc7aeb27729f2b800389fcc57"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa4cd1ed061613106588ca68a42455a067fd7dd3ce548b5f1ad4a551407ce42d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aef43f269ac4330356132b7439be35ab642cb43cf8074218b3a43e985414890"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9baeccb776308859725e64cbf76b4e66a2c0a16c8f641d92819849e31c6bd5c6"
    sha256 cellar: :any,                 x86_64_linux:  "11e3c94b4745a7df8c97ec3e6b5a8a23f314d1c0298b09f2bf8c015b6c1adde7"
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
