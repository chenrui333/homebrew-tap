class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.67.tar.gz"
  sha256 "358f6dc09e0ed494432d1b669ee1a9133bc20c285defbdc495ca29994b43b424"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d723d2a9b6a28e9291be7b3decb5ab5d1f74011dccad5f135e9102629ac46e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8917b05edebf6eb75777d744d4c44367d34e8a4403f202145c04f3c6a72feb85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d923920c24d16e17be118478017598fb78df0efddcbbed30a60df07d8394a14b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd803739e3e1e42283123b71f60a4551494d712e3fa75ed367bf4205f10b5b23"
    sha256 cellar: :any,                 x86_64_linux:  "9c776ae77a548835c1934f3fcdaa17e411fc2dd7282fff45ad021c408a997ad8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kptdev/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
