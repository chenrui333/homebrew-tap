class Pipeform < Formula
  desc "Terraform runtime TUI"
  homepage "https://github.com/magodo/pipeform"
  url "https://github.com/magodo/pipeform/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "0b251f3d0d259b0e3d15b08b95567f3eef123afae9c3d0e20107cd6f08aa6278"
  license "MPL-2.0"
  head "https://github.com/magodo/pipeform.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4537a0622eb7c6651f6e68f7835007237b206072939c6679ec19f068c93bba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "362326526d5d4aa13844e2910a80b3c33f62253c8bc642604feed06aec9d1654"
    sha256 cellar: :any_skip_relocation, ventura:       "7fb4d48afe9f200c7396a19e6b232c8f2f4b6560f57eda221176d06c7a67e024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec96a0100240bdb788d6c0a266bbdff791f3f26334c902cf86f6f147a1cf2dee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # TODO: need a better test to test pipe
    system bin/"pipeform", "--help"
  end
end
