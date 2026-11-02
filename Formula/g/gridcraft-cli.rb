class GridcraftCli < Formula
  desc "Headless GridCraft to inspect, convert and evaluate spreadsheets, with MCP"
  homepage "https://getartcraft.com/apps/gridcraft"
  url "https://github.com/storytold/gridcraft/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "6bc25221fccaeddd11bb98d31909880719ee9f06ef149520204a368e138c916b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/gridcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ccf308cca7740e57a478d484fb36864c8542d6c3dd5199bfb6bfe2f4f86f656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d286ab2bde13ea9b9b59e6141087f25e0e1068fe83232d91a7246d346cc8cc9"
    sha256 cellar: :any,                 arm64_linux:   "7fc272a61d06d9a853162ca023ebbba1f27953b948bb45f31f0f3718297ac699"
    sha256 cellar: :any,                 x86_64_linux:  "cc017169b93556211794fa3b536dff9b69ee7e60fb22f9e7485a02e78363f78d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/gridcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gridcraft-cli --version")
    assert_equal "6", shell_output("#{bin}/gridcraft-cli eval '=SUM(1,2,3)'").strip

    values = '{"range":"A1","values":[["Name","Qty"],["apple",3],["pear",4],["total","=SUM(B2:B3)"]]}'
    system bin/"gridcraft-cli", "run", "--cmd", "range.setValues=#{values}", "--out", "test.xlsx", "--quiet"
    system bin/"gridcraft-cli", "convert", "test.xlsx", "test.csv"
    assert_equal %w[Name,Qty apple,3 pear,4 total,7], (testpath/"test.csv").read.lines.map(&:chomp)
  end
end
