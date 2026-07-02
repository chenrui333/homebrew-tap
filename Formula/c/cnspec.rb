class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.27.3.tar.gz"
  sha256 "8206655c8958a0dc9fac05fe6d2e36213ad782ee442a44f17e2f07674f7de005"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bf43b77d1205afbdda80dee68db9a8f8de2f8b952366f0d59b1790b358eef34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2e334bf68b3b5a8203c098850ea28b40cf45f3bdfe748f8f771e2a7907524ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c2c50fd54399bfb427a78556d1aa397053f5b4bfc87b79850912c461091c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29abcaf672b96ba4f57594ee68b1b9816f9102d7987ada7b742cc573b8c8c7e8"
    sha256 cellar: :any,                 x86_64_linux:  "4f835edbda7f5473aafedb7af36326832ebe035081f27d42e8ce6e49da6b92ce"
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
