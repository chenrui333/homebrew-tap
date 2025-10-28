class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.7.0.tar.gz"
  sha256 "caf6bf031dbb0d69fe13f470222c70b31a6ed10af8410fbf859d077f9de74494"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "276d361a27487ffa6eb7c475b78bc75ccaea2bb08d9d3833883049e5b200e983"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b61f97dbf9f6ed4d610b2130d67fab883d1075808295f3ec7e7ca4c09edc81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7981a858f7d41cf2e8e4f5b97bd8c6f7839b3592f61a2ac51ad9ff7ba7e47226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a5a9793f2f1f728f695889e348e2bb072c273e6625fd96a3d8483a409a127ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb2a03ce25132141fe5efd8d940d511deb020459ef6e1ccb6a2fd6225e23ddaf"
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
