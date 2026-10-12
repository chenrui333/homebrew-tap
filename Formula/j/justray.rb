class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "3037a9d62dd79e0812828fb2fa7f113569cda856d196b85cb6310dadbad9f036"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c73be1938ea37236add21b9b3a622d1d62515a0bee37df92b112970e8f1ce7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa92c1f7531d13cceff6d2e022823c542452ed81e65a4eaa13056041989068ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b4506941cf454f4866bc609ec81a78b2b33d10dbce68000f31f49d87d4bfa5"
    sha256 cellar: :any,                 x86_64_linux:  "327d5fe6e329507ad559a8c9245f1cab8790079f4b28d85b3d066b23d7962a10"
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
