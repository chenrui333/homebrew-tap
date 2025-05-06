class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/development/cli/overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.29.6.tar.gz"
  sha256 "2ec1f8c0048c00c4d5012f498f74c55301c738033b988677c5b03a099e89e116"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bba686f3c2f6653dcfd2094b435cab782c8d116a34ab2196425a7c7299fc4d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "302e240766038ef3c33fc63e8a0c1d4b48d98fbcf834ea33fd5ed7747fb670c1"
    sha256 cellar: :any_skip_relocation, ventura:       "39ceba8efeef2c6f899b3acc0771c9351e4c378a36d3bbad34bc940fb661012a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61144e53d043bfc97df33ffb6309709c7a6a6af0b86f32fa945bcddee9589018"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end
