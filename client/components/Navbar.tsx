import React from 'react'
import Link from 'next/link'
import Image from 'next/image'
const navlinks = [
     {
        "name" : "Home",
        "link" : "/"
     },
     {
        "name" : "Explore",
        "link" : "/explore"
     }
]

const Navbar = () => {
  return (
    <div className='flex justify-between px-32'>
       <div className=''>
           Logo
       </div>
       <div className='flex justify-evenly'>
           {navlinks.map((data)=>(  
                <div className='mx-2'><Link href={data.link}>Home</Link></div>
           ))}
       </div>
    </div>
  )
}

export default Navbar