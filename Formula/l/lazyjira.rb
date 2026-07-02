class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "9b45872a6c283c9695e14d8db9d7006b4b5fd8157b44c03f81c5b83dfce7d521"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "591e12edccc89ce9adfdf605f62b967f1412a1303aa3d71836d2f7879bcfe1a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591e12edccc89ce9adfdf605f62b967f1412a1303aa3d71836d2f7879bcfe1a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "591e12edccc89ce9adfdf605f62b967f1412a1303aa3d71836d2f7879bcfe1a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f67c9a9abf119de03cae68dea39eebfb3418d4f878492a8389c31c98eba53375"
    sha256 cellar: :any,                 x86_64_linux:  "73c4ea3548dface125b8109925bd343f4a65ed8f896ec5eb13d67970d1fe1678"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
