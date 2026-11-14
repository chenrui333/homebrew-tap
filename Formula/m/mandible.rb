class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "a6274f1a76d75f36442d2d53f761519389270ccb62e14ac57ce2f73e5ad67237"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "189e8e32838b15fbb63f0e13915786ced2eb7d9c13c2c6efe178c3e1906020d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee8d4b68f90a29ac78d93acf441906398810f521dd49904c3e7588d61bc0da7"
    sha256 cellar: :any,                 arm64_linux:   "a0d7b94d41ce83b0885f4a2f1a905e55b309d16b8fdfa8d4d1d64856597d7c4d"
    sha256 cellar: :any,                 x86_64_linux:  "720bc4c8e52603ec72519da7b6d96519cce6ea3f189e8a81a010d86ad32ed8c6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
