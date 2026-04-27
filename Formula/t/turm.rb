class Turm < Formula
  desc "TUI for the Slurm Workload Manager"
  homepage "https://github.com/kabouzeid/turm"
  url "https://github.com/kabouzeid/turm/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6f1404336ba91be8b16a17f35cc3d24bce29538c1120005787d6abdb41d01536"
  license "MIT"
  head "https://github.com/kabouzeid/turm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d2073b762676bf2d5b3c7eb092de14fe62f0376f159081d25b2e91928e3a939"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85cb8a6b6b30de3b94877edf5dec6ee357849d06d727d4e26294bd937a79b8c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc290d644aa54180fced5ea28dd770b3ed78e7301dbf59c24e40b59b1f26cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d7f319f821397f51d102fa9332b111428843d2bdf9995bf94b26f48652ee674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4718d2daf53a07eb35b728d510375800ae0250394a797028c764a2ba1a180876"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"turm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/turm --version")

    output = shell_output("#{bin}/turm completion bash")
    assert_match "_turm()", output
    assert_match "complete -F _turm", output
  end
end
