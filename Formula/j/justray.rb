class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "7619596ebaf9c7440a3763bc3f7df3d08abad01015b50aa9eeeb7888a6fe1377"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d724293f17b1db6bb389be7a5d012e37eb95d2d595a608dfe5816000d78e697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b40c89427c23f177c8efa48215b1e9ff6f27721b20e1d273c8c58cd2cb2368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10db3b90b5166152ebec31de6ea5b3af0576025d7a1ac7cf059ffc5800398d82"
    sha256 cellar: :any,                 x86_64_linux:  "19557a61bcb0948ba2591f61322c57332cca172c0387bd59fad1066ffb4d6e0b"
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
