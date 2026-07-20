class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "bad2251858d8d49ce593020c33a90d5e3fe1b2353d8f7251fe658dbbaf5e70f4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "601ae44f88ecdd52062b2e9da3ce866e06e57551c402abcfe811d1d10a754430"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d955f5bdc7c55fbdbc7c688b316592c1cb66a4770eddd39f0732c26edf9e3d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a096ec7dc55735054befff0f723d2515f339dd2042aac74b8ea67e242ec7bf58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfd3b0f0104dc006a2cc9cca13b0b70cd8606175fc3a5162a0c1f37791a0a903"
    sha256 cellar: :any,                 x86_64_linux:  "798d39c25b47366b0790c0518e59c77504dedca8fa727e2105b266e0252ab931"
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

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
