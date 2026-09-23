class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8a4cfe84c84c9f0aeff389fe78d668829c39d086052bb70e8bb232ea64296217"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b794d0dcc712bb8089de3550fd29e53b9b43ae73127556abeaf51a7545d1a8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a385f5404e301b6477ddf68c90d1fd7b9456321d6270d2ca34fc7af5a7cb5b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c82484711436aa0ec6f79ca04f2124c33ced863f2407840edcadf570f6018327"
    sha256 cellar: :any,                 arm64_linux:   "9e120076b25e6ab57095e783314d3c452ea7800c2390787996a998e729669f09"
    sha256 cellar: :any,                 x86_64_linux:  "975a08913612ae8f8801080ad134c3bfcf457f44b1c3d112541187186cb5c0e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mandible")
    generate_completions_from_executable(bin/"mandible", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mandible --version")
    output = shell_output("#{bin}/mandible 2>&1", 1)
    assert_match "no tool given", output
  end
end
