class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "7619596ebaf9c7440a3763bc3f7df3d08abad01015b50aa9eeeb7888a6fe1377"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d814667c11c0193a0d2a252ce0cf0e000bf943762daabe74682d924131d1284a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5ad6bdeb3fba12cbfd6b6183764848d48700008a8b02d3cbe21e5c07e89fbce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9982b77802068a81de27c03b8905e67da0a0352b516094ccc022867823a70774"
    sha256 cellar: :any,                 x86_64_linux:  "e7309c762756520e47bda057359fa1957cfd790ad851bebbc5deda48fd9c6fa0"
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
