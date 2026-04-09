class Viwo < Formula
  desc "Docker-sandboxed virtual workspaces for Claude Code"
  homepage "https://github.com/OverseedAI/viwo"
  url "https://github.com/OverseedAI/viwo/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "a8e1fc048b483d4290eef6b1cb778ec5115279b26305bf5618fae85f4f2d1856"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "104ebd8f479126abd150564b44f4ba3fe601ae227a0e3cee65006f70b10b4390"
    sha256                               arm64_sequoia: "79027d4b272f7efe0405f7cf38e24f1679db403d5e4d2bafcdf6a06ea5511a63"
    sha256                               arm64_sonoma:  "f0d32a97261012779494f9dec87f4a104a0ed89007da204f879281771b65edeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af4fc0a27149a64c8bc2f835f64cc5e19460893dfcafd6189d7e68bed86dcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98e893eb5c53c47881e39f332b2f5eb264d37eae0fde3d1b7ab2edefc00c8caa"
  end

  depends_on "chenrui333/tap/bun" => :build

  def install
    Dir.chdir("packages/cli") do
      system "bun", "install", "--frozen-lockfile"
      system "bun", "build", "src/cli.ts", "--compile", "--outfile", "viwo"
      bin.install "viwo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/viwo --version")
  end
end
