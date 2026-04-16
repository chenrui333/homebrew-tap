class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "6af3cdda1579d6e16e0458ecdebef4642fa0607173fe327e58bee6df20bf642d"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdb43abd0de71eb449585a239bbd679497de5b13c4e7eba0bb22a68070141ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d40fe91349ef421e68866c60a7f67563492f9604662b0952b7d9691517b4a51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f66e8f6dcaa0f3b986d02c8b1156593da490c39a3ec59d60df43962cd6ea355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e8ea781befe8713333eb87deb5daffbd4d7a78278dbb3d6bd1042a680534b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7e7d2b9fca81b25a8988b97db8d2be5e74884b48bba70c379495239368a224"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
