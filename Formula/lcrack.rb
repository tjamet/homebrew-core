class Lcrack < Formula
  desc "Generic password cracker"
  homepage "https://packages.debian.org/sid/lcrack"
  url "https://deb.debian.org/debian/pool/main/l/lcrack/lcrack_20040914.orig.tar.gz"
  version "20040914"
  sha256 "63fe93dfeae92677007f1e1022841d25086b92d29ad66435ab3a80a0705776fe"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9a11f709651ff447bc6a4ef8868e52fbf44587d4631cbbcba248c5a61dae2a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a10b7d205bc60c5e719ca47f3ffe4c3a4d8a975c393cb1258daf2bac4ee0217"
    sha256 cellar: :any_skip_relocation, catalina:      "229ccd2408afb62d18a8ea9f68cf7d065720fb9137b1b14f9d4e7aaffc178865"
    sha256 cellar: :any_skip_relocation, mojave:        "d1d84ad9e2d7a9c6c8ed9eaedb70362ef362efa72c236aa9610ece7cefcd6029"
    sha256 cellar: :any_skip_relocation, high_sierra:   "9d903ca15b5614ebfef876b53ddba7bc6b7798d0a79a56fceb86b6518844103e"
    sha256 cellar: :any_skip_relocation, sierra:        "8e5fb5b2ad952ea17bc314a9ae49ce4baf736868448e833600c394b60d326846"
    sha256 cellar: :any_skip_relocation, el_capitan:    "2bd1de3426e4bd4ebfc6fb6026dc9a9fd046a5d9345459700a2361b7fe53f49c"
    sha256 cellar: :any_skip_relocation, yosemite:      "443e64bdb0307e12f4ef990abea7941239784cb7c9798929880a7973f86cf5bc"
  end

  def install
    system "./configure"
    system "make"
    bin.install "lcrack"

    # This prevents installing slightly generic names (regex)
    # and also mimics Debian's installation of lcrack.
    %w[mktbl mkword regex].each do |prog|
      bin.install prog => "lcrack_#{prog}"
    end
  end

  test do
    (testpath/"secrets.txt").write "root:5ebe2294ecd0e0f08eab7690d2a6ee69:SECRET"
    (testpath/"dict.txt").write "secret"

    output = pipe_output("#{bin}/lcrack -m md5 -d dict.txt -xf+ -s a-z -l 1-8 secrets.txt 2>&1")
    assert_match "Found: 1", output
  end
end
