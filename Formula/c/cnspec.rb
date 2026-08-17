class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.34.0.tar.gz"
  sha256 "2ea7ac111a264b1b524a19300d27b0f6c570eb3794c962e82f4889f4fa5c5985"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8a4da547f55f75421006c65ebb95155b2caf0126d14a409547719186ca8c2c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d50f3ab8c63c6b33edfbe235ee238973e0772a04083b7b658fc2a1f1716dcdc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a8311039a8781956e846e85222358fcb9c4a179249a6bd4cd8cf802fb86e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2711e4f780f9efc7cc5cdbe87f6e4dc117e49a81f952f45eb135e9213541e72"
    sha256 cellar: :any,                 x86_64_linux:  "86ffca6d94bed196fafd37eec25564211312234a75dae951ada65caa327098d2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
