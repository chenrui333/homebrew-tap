class Gowebly < Formula
  desc "Next-generation CLI tool to easily build amazing web applications"
  homepage "https://gowebly.org/"
  url "https://github.com/gowebly/gowebly/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "c7fdc2740199d1bc3bd371e527f093025be9484e61439c6a9361522569a3813f"
  license "Apache-2.0"
  head "https://github.com/gowebly/gowebly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2432dda8d8b3a23c2745cbb13fa2ca35279b6db6fbb475946bda42fffbd4e078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2432dda8d8b3a23c2745cbb13fa2ca35279b6db6fbb475946bda42fffbd4e078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2432dda8d8b3a23c2745cbb13fa2ca35279b6db6fbb475946bda42fffbd4e078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa88a90e33ab4f61afab9e33dcb625ac3c48f27e9d7533a83393f3eb8c8db0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4224d7a130a0b4228e0452b40f62fe0e4d3f1337925439a66970f591263408c0"
  end

  depends_on "go" => :build

  def install
    inreplace "internal/variables/version.go",
              /var GoweblyVersion string = "v[\d.]+"/,
              "var GoweblyVersion string = \"v#{version}\""

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gowebly doctor")

    output = shell_output("#{bin}/gowebly run 2>&1", 1)
    assert_match "No rule to make target", output
  end
end
