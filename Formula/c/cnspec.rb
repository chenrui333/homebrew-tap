class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.9.0.tar.gz"
  sha256 "d76cadbc4b87af81ffa281a3d27913abc5bebf3a162b0584b48fb0df4cf28df0"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "962e56158b93a62deefde7e3ecb98d61f364d9e2a6b8b6eb7a2abf11b5a1fa1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7308140b67fd537f207e458ba54de62fcf6530baa1bdc3b6b895f037e47cf999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d6e8e955863694272b471fdf8ffacb2b2c0dd52f1bf1556f61b515d8a17d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df8859851c5b00c447d508ad72080846e0cbde933a1a530c35d023d11f4d4b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b159a475d45d7240a5459b10fc5d3997fd8641ba6a579ccebdead60f5d89fa3"
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
