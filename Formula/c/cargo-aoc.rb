class CargoAoc < Formula
  desc "Simple CLI tool that aims to be a helper for Advent of Code"
  homepage "https://github.com/gobanos/cargo-aoc"
  url "https://github.com/gobanos/cargo-aoc/archive/refs/tags/0.3.7.tar.gz"
  sha256 "4e7695d8038d0e3c7f129943bc951adc41922e7ad6f7f9b6a9aaa3ce2d95e918"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/gobanos/cargo-aoc.git", branch: "v0.3"

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-aoc")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    system "cargo", "aoc", "--version"

    output = shell_output("cargo aoc credentials")
    assert_match "Error: No session token available", output
  end
end
