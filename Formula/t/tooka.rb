class Tooka < Formula
  desc "CLI for the Tooka engine"
  homepage "https://github.com/tooka-org/tooka"
  url "https://github.com/tooka-org/tooka/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "c8784ee56cd59a889faa4a93051cc8efdf12564541e7716807c3662151fb90b0"
  license "GPL-3.0-only"
  head "https://github.com/tooka-org/tooka.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0498cee5793eeb9c72561577364da56e946543b2810607d65971d754599c4012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5ca764b3e7caf7607805cb4ceb58ec1babb553d74b3229b69ad062d6c9afe14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61a3bdc7b490f41b4c7bab7f3a43fa5a3d604979ff5513a0497fabe67f3c29d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ea9870cb881edbd764e10f40ed6b18c9146e3395670c4b1051ad5b971b8fd09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"tooka", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tooka --version")
    assert_match "No rules found", shell_output("#{bin}/tooka list")
  end
end
