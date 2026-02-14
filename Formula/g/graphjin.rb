class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "c734b5030ed2ef738baac2effe093bfdf052e4186e075e8190eb9ae8f621b7b8"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b499d2df10d516fd13322731ee08ab36a67f565ffb1f370c923475840ebc2801"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2165d3c6faa8b52668f286586ba144385e3c98b22bc40d4d3e845e94ce2baf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b734b28504154e1a2e2166d26ef0f098aecc254dd6cd1362d9d813c093cf8194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c6d2611ccc10489211185fc1beb6d5d8e76082b60fc58b774c8c739628a07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d768ad43ba604054aeeacde0bb0efb98c7ec03540a86a055600ef2df3f863bbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
