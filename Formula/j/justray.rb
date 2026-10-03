class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "eff5c101ad38452ce23f86e2297adebfe8f27750a2ce023f9781a6985d642ba0"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa45c70f683fc74b47cf2c9968ca8ef76771a689ea88b111c6e1fd7d3d3fc149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f985cd38cb0229cf42255425d3c324b196622beba37f1cf6c4ab3fc8eccf4653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f163fffd08145e401bd14265bacab4bf15385f3461b50344e4a1060f75546a0"
    sha256 cellar: :any,                 x86_64_linux:  "d3485e349178e81278b02f796b123f2dc27c286178a2aa863de729873118d948"
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
