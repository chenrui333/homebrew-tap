class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.12.0.tar.gz"
  sha256 "b2e63d37e24b83dcf9832a8494c419489a12f8089777f90dff80a98a7e3aeaec"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6d8fdd149d7855d842d3e363d5f237ed556c2f054471bb0a8ff4d19075f6a51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f83ecd520bc02438ad528922b78cea65e4427cba1cff9cec379c1d60d2d5c0eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab73a1185b18229188a1e0a275a7d83be3e5f2271ba88af7883e34b783f90244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d50c10445f545ad4fac3a615a489198639359cdadc1918e0a6626b1dbc65f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cabff0e8653de4d83b13941bd4cd26fb302a79c6f2768d3ea9d9f52ab153bc2"
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
