class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "c0ddc148e1840eb4a75b322eb52f92a216b64d204aa53d6f93b222a1ed9adb36"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6183b3fcb1ac6e64560bfebbd34f8b79d8f444191e35a99914a10561ae22f431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6183b3fcb1ac6e64560bfebbd34f8b79d8f444191e35a99914a10561ae22f431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9704de909cd0f22b0eb046ce8ef8e6971277d1ace4b6431d31b8d41303206b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c817ab1aed243fbef1fed2160f82917d31629bae874fdaf762d9436140b09f06"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/chroncal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chroncal version")

    ENV["CHRONCAL_DB"] = testpath/"chroncal.db"
    assert_equal "[]\n", shell_output("#{bin}/chroncal todo list --output json")
  end
end
