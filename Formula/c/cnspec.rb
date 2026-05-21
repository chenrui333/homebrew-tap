class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.11.0.tar.gz"
  sha256 "3cff7944f48b9bfee8e7cdc4b4219e3550abc82de92260c8cd403f1ef242090f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4abfbf4910f8bf129bb2ae4da2f0b5d1ea9bb5fdea88f711f8b007d5603d24b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a15a054d11c52fed85ceee885abac9b1bfb077bebf7d57777255e7c3190eda8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8549ad67d6375f30f29d7e5cfaf8af807303ca9349ecef80a60ed8c34364e197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a899308dfe8b287c535da2c8da6cad3596372a046216bb1d761a6aa261f7ca0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301feab633a0d447291938a02366aab0329b2ec6a01bd2530ea39405a9de2b1f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
