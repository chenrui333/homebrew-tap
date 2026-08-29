class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.68.tar.gz"
  sha256 "2da285ec985f680f597f969bc391fb4719075d0d7ba0ea1fc7803e2d8fa6b149"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb03e3802a7f11c2faf1ea7df858b046249ba1c32a08fbc8576f3680508f8f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db8ef5f3503da4c6968440833770fab5b8f139e92ebe2006050b3c8c188cf5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b890cb8c1d6d304b78af61c5b2fc70d58788f98ff5f37368bc9074f3373892f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5027dbdf5243bedcb9da79eb0112865d8c49eda82c813e2283923af52c1a5ee3"
    sha256 cellar: :any,                 x86_64_linux:  "a5a021bdb84c4434a0a9f04731c331512cb3b4dbb862d601757ea3c4e2506808"
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
