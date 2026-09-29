class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.2.0.tar.gz"
  sha256 "897b40643d04ad6e07833316511199e3d010702053e3ce142d53b6c166ee7d3c"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aca45f083fff9b31bc1911aed88f4a0e679f33dfca6d79831397c02f9e83857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4905fee8d89f22d5f363a95954fa12e3783b526731898a66e20af057198dc37c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "783c901881eea890639df13010b82cef33f2f2fc96063743ada8467f46050933"
    sha256 cellar: :any,                 x86_64_linux:  "4417d7d320800662634651d98eece597d6e203fe8c914fd267ddfaf0c29015d6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
