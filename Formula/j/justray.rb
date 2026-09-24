class Justray < Formula
  desc "Terminal VPN client"
  homepage "https://github.com/luynrs/justray"
  url "https://github.com/luynrs/justray/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "f85a7515f8986032402074e22d705ec2d4f800aea3a56736c47f6c6c0f85ab3c"
  license "GPL-3.0-only"
  head "https://github.com/luynrs/justray.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc802536e4169c3dcaad8b13003b221407e48436e345512518cbedf5529d8285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "111210c43a83e6fffc3ccedd7a863294d5526e088448e6d10c35b4ac11cb2f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "321d42e8f8e4537e57cbcdf86c11379ff987c16201843f708db6b2ebf0c48054"
    sha256 cellar: :any,                 x86_64_linux:  "9c80afb224be3a0225a6e0d0a1c60148bdc69f6745a8cd8195bdf346115a7045"
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
