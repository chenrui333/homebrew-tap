class Gignr < Formula
  desc "Effortlessly Manage and Generate .gitignore files"
  homepage "https://github.com/jasonuc/gignr"
  url "https://github.com/jasonuc/gignr/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "f7b4d820de3230c59c999f7a85e6652ad74dfba03f41f90f946b48c0d8f04578"
  license "MIT"
  head "https://github.com/jasonuc/gignr.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gignr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gignr --version")

    # failed due to github api rate limit
    # assert_match "Created .gitignore file", shell_output("#{bin}/gignr create gh:Go tt:clion my-template")
    # assert_match "Binaries for programs and plugins", (testpath/".gitignore").read
  end
end
