class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.15.0.tar.gz"
  sha256 "1f189bd8b2e75ab6d52e6fc5cc8a2d14491bc4c9e8cba60cf67df19e1fd4eb0a"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08263b86adf7d98ac36373846398c77b18999ae520ae9b440a8b5423b63846d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56a41d16821ca9909e9ad3bc89ca567b063d6fa8f87b914cbcbbdf2a440c8ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ae61c8cb550317aed4e0c75916e3bbca775b37b305122a563e9c038dc15b8cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4063e959d18e110be3a20cf8fb9d889dca84633a62845b5a83fea0246948599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da938ee7c94f58f71f0e5e73ee63000bbd390dd061d86d90a11849a0f06457c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
