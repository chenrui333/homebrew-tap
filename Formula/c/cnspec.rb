class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.17.0.tar.gz"
  sha256 "b52005d34ced91f96c6b3c02f7cf0e34ee68513c8ad676f8ac934bbe9f87dd10"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18180f362c7c617405883aa56a002e8a18f6368fbfd4dae1e5512085da5200d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "626e2c23191f16fb5434c11767fcebf4f45424a676b31bd401855345b1dfc123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b810223b4e75c6c0367c2d42e66e687379b4bb3eac9acb83d7a7a0269ec7b2d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f4e092c18d7b6678d62c7ca64393fa4f11d40d8cabc71ea30decd45a29fe8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3a2d605b72eb704d2795a2c760cd6d76080199e1b6ce308046495a85e17c1d"
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
