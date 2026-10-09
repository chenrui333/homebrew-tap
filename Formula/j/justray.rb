class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "6b7b1cf25fa2a8593939b6a0dae8e564722fb527d38dc3bc3b9a29db32e99104"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37b3d3615d88f43dbe5a90d60f54a13c77fddaf3aa61fe7eac39d28ebe8aa829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6a6a5c5c688547e62e448a2748b60901f9e070a76765f0d2b17de17744fad3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79c718d6a104b530f932a7df8e8f64ea7677a93a57c07b8d67c5baab0d4d8322"
    sha256 cellar: :any,                 x86_64_linux:  "b8b46dd4da44b891974fdf096ab0ad7a20b682ae7d8b63bd2b298085e9d52b15"
  end

  # Match upstream release CI; sing-box relies on private HTTP/2 symbols.
  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
