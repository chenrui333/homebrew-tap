class Gignr < Formula
  desc "Effortlessly Manage and Generate .gitignore files"
  homepage "https://github.com/jasonuc/gignr"
  url "https://github.com/jasonuc/gignr/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "f7b4d820de3230c59c999f7a85e6652ad74dfba03f41f90f946b48c0d8f04578"
  license "MIT"
  head "https://github.com/jasonuc/gignr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc914213a77e3e3d2cc3e5e0499fdb982ebf8bda92558bdbd82e650ca89b0283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc914213a77e3e3d2cc3e5e0499fdb982ebf8bda92558bdbd82e650ca89b0283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc914213a77e3e3d2cc3e5e0499fdb982ebf8bda92558bdbd82e650ca89b0283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50bb7de3458c887e602e58b17d92f67e2d36d4fbac5b5d85162d3d0c234983a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733b271f8ea3d3edf91b7903c71f3e47fbbf49d3f377ad5117c58eef746038be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gignr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gignr --version")

    # failed due to github api rate limit
    # assert_match "Created .gitignore file", shell_output("#{bin}/gignr create gh:Go tt:clion my-template")
    # assert_match "Binaries for programs and plugins", (testpath/".gitignore").read
  end
end
