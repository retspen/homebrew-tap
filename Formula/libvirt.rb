class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.0.0.tar.xz"
  sha256 "e6bb642389bbace3252c462bbb2e9b1749dd64315b9873a424f36c7f8d357f76"
  
  depends_on "docutils"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "rpcgen" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --with-init-script=none
      --with-remote
      --with-test
      --without-libvirtd
    ]

    args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen" 

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    mkdir "build" do
      system "../configure", *args

      # Compilation of docs doesn't get done if we jump straight to "make install"
      system "make"
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/virsh -V")
    assert_match "Compiled with support for:", output
  end
end
