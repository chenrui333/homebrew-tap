class Nosy < Formula
  desc "CLI to summarize various types of content"
  homepage "https://github.com/ynqa/nosy"
  url "https://github.com/ynqa/nosy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5f830d6398868540a0168aa3f0fbf38c2b85657f3d2af27ccaa51128b817f646"
  license "MIT"
  head "https://github.com/ynqa/nosy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19b5a5bfe7591cd1eb2dbeb317204489cee534a72d771d8712fdc46eb16a6c29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85edb5c5b81827e5cc8b7ad04a43489f2528ea9af147ec9b2087f98918fdd7e8"
    sha256 cellar: :any,                 arm64_linux:   "6d3f8db3488573cd689ce29befc34b6373b1c2599f1fd1da1de5415c833e6f46"
    sha256 cellar: :any,                 x86_64_linux:  "4ec799da4afcde340a26f3df97c18af72f7c6e916cc02cc7f9252ec82425fdc4"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  on_linux do
    # bindgen 0.71 (via whisper-rs-sys 0.14) emits opaque structs with libclang 22+
    # TODO: Remove when https://github.com/rust-lang/rust-bindgen/issues/3275 fix (bindgen 0.72.1) is used
    depends_on "llvm@21" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm@21") if OS.linux?

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"nosy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nosy --version")
    assert_match "nosy", shell_output("#{bin}/nosy completion bash")
  end
end
