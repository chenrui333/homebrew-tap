class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.27.3.tar.gz"
  sha256 "8206655c8958a0dc9fac05fe6d2e36213ad782ee442a44f17e2f07674f7de005"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e3eb3bb9387e74d74ea11e1d86fdeb8eb997207ad49bc64c8d3a4d58c09b7b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c35477ce2ef498149b7b0fff3353911a7deddba5616c9ec0e68738b0065d7c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8934f1f32d61d1b767a8fe515c1492a700981cec95bdd43706731427d01b9e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e435453c9ff60de33f2c23bde5365de06c412a2175d18cce000122ca36794bf0"
    sha256 cellar: :any,                 x86_64_linux:  "b9a6cba8812b8c544ea04ede08e5381ecb821dfb76400330d9f8163338bd7afe"
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
