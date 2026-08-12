class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.15.tar.gz"
  sha256 "920a8376ed7fa9509d94b02dbcd1dd9d70ded568c0021f82611f5ed0c7153fc6"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f1fab20b35dc96d607c44e4534275ac4fe1b2510b4d4d10775c0e144cfacad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d614be6f1ffdf4f64ddf407265588d4ba0aaca2372b936501c288379a7407d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bd83173d6ed1d12b2355e4862d180f197a7f6012bbbe18428495b8e534e8996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "339d8153916a694ad826d43e60e64835264b58784d7bf294b9296ccecf47fced"
    sha256 cellar: :any,                 x86_64_linux:  "c452ae0a72044d134bb91fa8ffd138c30e07df8f24d1e2923ca551458865bea3"
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
