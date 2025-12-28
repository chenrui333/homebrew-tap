class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.15.0.tar.gz"
  sha256 "1f189bd8b2e75ab6d52e6fc5cc8a2d14491bc4c9e8cba60cf67df19e1fd4eb0a"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d503a1355fb0999c1a4623eb82a5bc593a6b128cc453423e8739fab910b9e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48936202296d145c259f031a67a1ee83002963d0fd4d3e9537919d7d0d2b1d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e29d69576982f195356dcc7da5c369d7a52b13e16d4dd9bd271a6a7ce4e926da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "835ae77951c75af82a2ad9f71b6550fd0751d3a1c714f6fc726758ea0ce851b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1e8723131e16f476fd2e54f356e461b53fe6f41b4d82fa595d7badef88cc0d8"
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
