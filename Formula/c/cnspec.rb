class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.5.0.tar.gz"
  sha256 "9241f178c1a29911f8034a70ed7c7aaae856520219ed19c6755e4102e4627cd8"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dff9461cbc34b159d734c0bd073001c745d6e80e516376e3d5f78f7fc7f065e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09961a5cf1054a6ffc662b44cd51dd22a39c2ce28738dc36ec15bfaf8e14877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "787232476d037704e53ca80901d3ed6c2567bd2e0f58eabc0c569b5f39c5448d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970140cd148b5c81ddeffb07d3cc1bec97e5a022ac79a95f4e72442a41f898a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add775fbd2d68f928e2476132a2a03cc8c7e47593d0c8f90d42a95b1736b7bca"
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
