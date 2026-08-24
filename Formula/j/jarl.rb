class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.6.0.tar.gz"
  sha256 "86620fcdb654d18be5f9fc62257ff577eade56cb1a6d9a3bc7d6e6857006a8a7"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb1497392db33a9b72b13c7c286f46da342657bcd3efa55c6bdabf6592abe987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "670838870836f96d02b9e3aec5aedf3321f705ffdaa626e88aa29706aa56bcb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d955d23dade0b9b9d249226636b9d6c73b33d30912520fd4edfb4255d2324b7"
    sha256 cellar: :any,                 arm64_linux:   "49f0640442c7361b4bff50ebb21c7281a0c5ff52c97323ac759e9b1957f21dc9"
    sha256 cellar: :any,                 x86_64_linux:  "ea68c04822c760d16e6873e48e525d15e0785f66a36e352a4e16dfaf6318b0b2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    (testpath/"test.R").write <<~R
      x = 1
      y <-2
      print( x +y )
    R

    output = shell_output("#{bin}/jarl check --select assignment #{testpath}/test.R 2>&1", 1)
    assert_match "Found 1 error", output

    output = shell_output("#{bin}/jarl check --select assignment --fix --allow-no-vcs #{testpath}/test.R")
    assert_match "All checks passed!", output
  end
end
